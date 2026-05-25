using System.Security.Cryptography;
using System.Text;

namespace EduFlow.Services
{
    public static class SecurityService
    {
        private const int Pbkdf2Iterations = 100000;
        private const int SaltSize = 16;
        private const int KeySize = 32;

        /// <summary>Yeni kayitlar icin salt'li PBKDF2 hash uretir.</summary>
        public static string HashPassword(string password)
        {
            var salt = new byte[SaltSize];
            using (var rng = RandomNumberGenerator.Create())
                rng.GetBytes(salt);

            var key = DeriveKey(password, salt, Pbkdf2Iterations);
            return string.Join("$",
                "PBKDF2",
                Pbkdf2Iterations,
                System.Convert.ToBase64String(salt),
                System.Convert.ToBase64String(key));
        }

        public static bool VerifyPassword(string password, string storedHash)
        {
            if (string.IsNullOrEmpty(storedHash))
                return false;

            if (storedHash.StartsWith("PBKDF2$", System.StringComparison.Ordinal))
                return VerifyPbkdf2(password, storedHash);

            return FixedTimeEquals(HashSha256(password), storedHash);
        }

        public static string HashSha256(string password)
        {
            using (var sha = SHA256.Create())
            {
                var bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password ?? string.Empty));
                var builder = new StringBuilder(bytes.Length * 2);
                foreach (var b in bytes)
                    builder.Append(b.ToString("x2"));
                return builder.ToString();
            }
        }

        /// <summary>Overload: email parametresi geriye donuk imza uyumlulugu icin kabul edilir.</summary>
        public static string HashPassword(string password, string email)
            => HashPassword(password);

        private static byte[] DeriveKey(string password, byte[] salt, int iterations)
        {
            using (var pbkdf2 = new Rfc2898DeriveBytes(password ?? string.Empty, salt, iterations, HashAlgorithmName.SHA256))
                return pbkdf2.GetBytes(KeySize);
        }

        private static bool VerifyPbkdf2(string password, string storedHash)
        {
            var parts = storedHash.Split('$');
            if (parts.Length != 4 || !int.TryParse(parts[1], out var iterations))
                return false;

            try
            {
                var salt = System.Convert.FromBase64String(parts[2]);
                var expected = System.Convert.FromBase64String(parts[3]);
                var actual = DeriveKey(password, salt, iterations);
                return FixedTimeEquals(actual, expected);
            }
            catch
            {
                return false;
            }
        }

        private static bool FixedTimeEquals(string left, string right)
            => FixedTimeEquals(Encoding.UTF8.GetBytes(left ?? string.Empty), Encoding.UTF8.GetBytes(right ?? string.Empty));

        private static bool FixedTimeEquals(byte[] left, byte[] right)
        {
            var diff = left.Length ^ right.Length;
            var length = left.Length < right.Length ? left.Length : right.Length;
            for (var i = 0; i < length; i++)
                diff |= left[i] ^ right[i];
            return diff == 0;
        }
    }
}
