using ExcelDna.Integration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace excelDnaTemplate
{
    public class TestFunctions
    {
      [ExcelFunction(Name = "testEchoFunc", Category = "Schuhi")]
      public static string testEchoFunc(string text)
      {
         return text;
      }

      [ExcelFunction(Name = "testFormatDate", Category = "Schuhi")]
      public static string testFormatDate(object oExcelDate)
      {
         var dt = ExcelDataConverters.TryGetDateTime(oExcelDate);
         return dt.ToString();
      }

      [ExcelCommand(MenuText = "HelloWorld", MenuName = "Schuhi")]
      public static void testCommand()
      {
         MessageBox.Show("Hello World!");
      }

   }
}
