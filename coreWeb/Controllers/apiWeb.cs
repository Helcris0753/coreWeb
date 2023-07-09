using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Data;
using System.Data.SqlClient;


namespace coreWeb.Controllers
{
    [ApiController]
    [Route("buscador")]
    public class apiWeb : ControllerBase
    {
        public SqlConnection connection = new SqlConnection("Data Source=DESKTOP-0MC2VK8;Initial Catalog=Web;Integrated Security=True");

        [HttpGet]
        [Route("busqueda")]
        public dynamic busqueda(string q, int page)
        {
            connection.Open();
            string paginas = "";
            int cuentas = 0;

            using (SqlCommand command = new SqlCommand("consultasWeb", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@consulta", q);
                command.Parameters.AddWithValue("@numPagina", page < 1 ? 1 : page);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        paginas = reader.IsDBNull(0) ? "[{\"url\":\"not found\",\"titulo\":\"not found\",\"descripcion\":\"not found\"}]" : reader.GetString(0);
                        cuentas = reader.GetInt32(1);
                    }
                }
            }
            connection.Close();

            var results = JsonConvert.DeserializeObject<dynamic>(paginas);

            var data = new
            {
                results = results,
                pages = cuentas
            };
            return JsonConvert.SerializeObject(data);
        }
    }
}
