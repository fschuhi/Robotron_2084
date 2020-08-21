using ExcelDna.Integration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Robotron
{
   /// <summary>
   /// The excel converters.
   /// </summary>
   public static class ExcelDataConverters
   {
      /// <summary>
      /// The try get date time.
      /// </summary>
      /// <param name="oExcelDate">
      /// The o excel date.
      /// </param>
      /// <returns>
      /// The <see cref="DateTime"/>.
      /// </returns>
      /// <exception cref="ArgumentException">
      /// </exception>
      public static DateTime TryGetDateTime(object oExcelDate)
      {
         // http://www.clear-lines.com/blog/post/Converting-Excel-date-format-to-SystemDateTime.aspx

         // We often have a null in Date field which translates into a double if 0.0.
         // Problem: 0.0 is not a valid date, it does not exist, see http://www.cpearson.com/excel/datetime.htm
         // ==> We cast the null in the first valid Excel date = 1.1.1900.
         double excelDate = oExcelDate == null ? excelDate = 1.0 : TryGetDoubleValue(oExcelDate);

         // We still have to check if user wants to convert e.g. -5 :)
         if (excelDate < 1)
         {
            throw new ArgumentException("Excel dates cannot be smaller than 1.");
         }

         // Lotus backwards compatibility fixes
         var dateOfReference = new DateTime(1900, 1, 1);
         if (excelDate > 60d)
         {
            excelDate = excelDate - 2;
         }
         else
         {
            excelDate = excelDate - 1;
         }

         return dateOfReference.AddDays(excelDate);
      }

      /// <summary>
      /// The try get double value.
      /// </summary>
      /// <param name="obj">
      /// The obj.
      /// </param>
      /// <returns>
      /// The <see cref="double"/>.
      /// </returns>
      public static double TryGetDoubleValue(object obj)
      {
         if (obj == null)
         {
            return 0.0;
         }
         else if (obj is double || obj is int || obj is decimal)
         {
            return Convert.ToDouble(obj);
         }
         else if (obj is bool)
         {
            return Convert.ToDouble((bool)obj);
         }
         else
         {
            return 0.0;
         }
      }

      /// <summary>
      /// The tryp get int value.
      /// </summary>
      /// <param name="obj">
      /// The obj.
      /// </param>
      /// <returns>
      /// The <see cref="int"/>.
      /// </returns>
      public static int TrypGetIntValue(object obj)
      {
         if (obj is int)
         {
            return (int)obj;
         }
         else
         {
            return (int)TryGetDoubleValue(obj);
         }
      }

      /// <summary>
      /// The try get bool value.
      /// </summary>
      /// <param name="obj">
      /// The obj.
      /// </param>
      /// <returns>
      /// The <see cref="bool"/>.
      /// </returns>
      public static bool TryGetBoolValue(object obj)
      {
         if (obj == null)
         {
            return false;
         }
         else if (obj is bool)
         {
            return (bool)obj;
         }
         else if (obj is int)
         {
            return TrypGetIntValue(obj) != 0;
         }
         else if (obj is double)
         {
            return TrypGetIntValue(obj) != 0;
         }
         else if (obj is string)
         {
            return obj.ToString().Trim().ToLower() == "true";
         }
         else
         {
            return false;
         }
      }

      /// <summary>
      /// The try get string value.
      /// </summary>
      /// <param name="o">
      /// The o.
      /// </param>
      /// <returns>
      /// The <see cref="string"/>.
      /// </returns>
      public static string TryGetStringValue(object o)
      {
         // should never happen - there is no null value in ExcelDna
         if (o == null)
         {
            return string.Empty;
         }

         // Empty cell on Excel sheet.
         if (o is ExcelEmpty)
         {
            return string.Empty;
         }

         // Missing parameter (i.e. not supplied by Excel)
         if (o is ExcelMissing)
         {
            return string.Empty;
         }

         // Any error, including #NA
         if (o is ExcelError)
         {
            return string.Empty;
         }

         return o.ToString();
      }

      /// <summary>
      /// The is missing.
      /// </summary>
      /// <param name="o">
      /// The o.
      /// </param>
      /// <returns>
      /// The <see cref="bool"/>.
      /// </returns>
      public static bool IsMissing(object o)
      {
         return o is ExcelMissing;
      }

      /// <summary>
      /// The is empty.
      /// </summary>
      /// <param name="o">
      /// The o.
      /// </param>
      /// <returns>
      /// The <see cref="bool"/>.
      /// </returns>
      [ExcelFunction]
      public static bool IsEmpty(object o)
      {
         return (o.ToString() == string.Empty) || (o is ExcelEmpty);
      }

      /// <summary>
      /// The is error.
      /// </summary>
      /// <param name="o">
      /// The o.
      /// </param>
      /// <returns>
      /// The <see cref="bool"/>.
      /// </returns>
      public static bool IsError(object o)
      {
         return o is ExcelError;
      }

      /// <summary>
      /// The is ok.
      /// </summary>
      /// <param name="o">
      /// The o.
      /// </param>
      /// <returns>
      /// The <see cref="bool"/>.
      /// </returns>
      public static bool IsOk(object o)
      {
         return !(IsEmpty(o) || IsError(o));
      }

      /// <summary>
      /// The safe double.
      /// </summary>
      /// <param name="o">
      /// The o.
      /// </param>
      /// <returns>
      /// The <see cref="double"/>.
      /// </returns>
      [ExcelFunction]
      public static double SafeDouble(object o)
      {
         return TryGetDoubleValue(o);
      }

      public static object ReplaceDataInMatrix(object[,] matrix, Type replaceType, object replaceValue)
      {
         for (int rowIndex = matrix.GetLowerBound(0); rowIndex <= matrix.GetUpperBound(0); rowIndex++)
         {
            for (int colIndex = matrix.GetLowerBound(1); colIndex <= matrix.GetUpperBound(1); colIndex++)
            {
               object o = matrix[rowIndex, colIndex];
               if (o != null)
               {
                  if (o.GetType() == replaceType)
                  {
                     matrix[rowIndex, colIndex] = replaceValue;
                  }
               }
            }
         }

         return matrix;
      }

      /// <summary>
      /// The get data table.
      /// </summary>
      /// <param name="matrix">
      /// The matrix.
      /// </param>
      /// <param name="hasHeader">
      /// The has header.
      /// </param>
      /// <returns>
      /// The <see cref="DataTable"/>.
      /// </returns>
      public static DataTable GetDataTable(object[,] matrix, bool hasHeader)
      {
         var dt = new DataTable();

         for (int ixCol = matrix.GetLowerBound(1); ixCol <= matrix.GetUpperBound(1); ixCol++)
         {
            DataColumn dataColumn;
            if (hasHeader)
            {
               object oCellValue = matrix[matrix.GetLowerBound(0), ixCol];
               string colname = oCellValue.ToString();

               dataColumn = !dt.Columns.Contains(colname) ? dt.Columns.Add(colname) : dt.Columns.Add(colname + "_" + ixCol);
            }
            else
            {
               dataColumn = dt.Columns.Add();
            }

            dataColumn.DataType = typeof(object);
         }

         int firstRowIndex = matrix.GetLowerBound(0) + (hasHeader ? 1 : 0);

         for (int rowIndex = firstRowIndex; rowIndex <= matrix.GetUpperBound(0); rowIndex++)
         {
            DataRow row = dt.Rows.Add();

            int dataTableColIndex = 0;
            for (int colIndex = matrix.GetLowerBound(1); colIndex <= matrix.GetUpperBound(1); colIndex++)
            {
               object oCellValue = matrix[rowIndex, colIndex];
               row[dataTableColIndex] = oCellValue;
               dataTableColIndex++;
            }
         }

         return dt;
      }

      public static bool IsValidObjectMatrix(object oMatrix)
      {
         return oMatrix is object[,];
      }

      public static object[,] CheckIfValidObjectMatrix(object oMatrix)
      {
         if (!(oMatrix is object[,]))
         {
            throw new Exception("Invalid matrix");
         }

         return (object[,])oMatrix;
      }

      public static double[] GetDoubleArray(object matrix)
      {
         // return GetTypedArray(CheckIfValidObjectMatrix(matrix), TryGetDoubleValue);
         return GetTypedArrayEx(CheckIfValidObjectMatrix(matrix), TryGetDoubleValue);
      }

      public static DateTime[] GetDateTimeArray(object matrix)
      {
         return GetTypedArray(CheckIfValidObjectMatrix(matrix), TryGetDateTime);
      }

      public static double[,] GetDoubleMatrix(object oMatrix)
      {
         object[,] objectMatrix = CheckIfValidObjectMatrix(oMatrix);

         var result = new double[objectMatrix.GetLength(0), objectMatrix.GetLength(1)];

         for (int rowIndex = objectMatrix.GetLowerBound(0); rowIndex <= objectMatrix.GetUpperBound(0); rowIndex++)
         {
            for (int colIndex = objectMatrix.GetLowerBound(1); colIndex <= objectMatrix.GetUpperBound(1); colIndex++)
            {
               result[rowIndex, colIndex] = ExcelDataConverters.TryGetDoubleValue(objectMatrix[rowIndex, colIndex]);
            }
         }

         return result;
      }

      public static string[] GetStringArray(object matrix)
      {
         if (!IsValidObjectMatrix(matrix))
         {
            string s = TryGetStringValue(matrix);

            if (string.IsNullOrEmpty(s))
            {
               return new string[] { };
            }

            return new string[] { s };
         }

         return GetTypedArrayEx(CheckIfValidObjectMatrix(matrix), TryGetStringValue);
      }

      public static object[] GetObjectArray(object matrix)
      {
         if (!IsValidObjectMatrix(matrix))
         {
            return new object[] { matrix };
         }

         return GetTypedArrayEx(CheckIfValidObjectMatrix(matrix), o => o);
      }

      public static T[] GetTypedArrayEx<T>(object[,] matrix, Func<object, T> convertFunc)
      {
         if ((matrix.GetLength(0) != 1) && (matrix.GetLength(1) != 1))
         {
            throw new Exception("Invalid array dimensions");
         }

         T[] result;
         if (matrix.GetLength(0) == 1)
         {
            result = new T[matrix.GetLength(1)];
            for (int i = matrix.GetLowerBound(1); i <= matrix.GetUpperBound(1); i++)
            {
               result[i] = convertFunc(matrix[matrix.GetLowerBound(0), i]);
            }
         }
         else
         {
            result = new T[matrix.GetLength(0)];
            for (int i = matrix.GetLowerBound(0); i <= matrix.GetUpperBound(0); i++)
            {
               result[i] = convertFunc(matrix[i, matrix.GetLowerBound(1)]);
            }
         }
         return result;
      }

      public static T[] GetTypedArray<T>(object[,] matrix, Func<object, T> convertFunc)
      {
         DataTable dt = GetDataTable(matrix, false);
         if (dt.Columns.Count != 1)
         {
            throw new Exception("Invalid double array");
         }

         var result = new T[dt.Rows.Count];
         for (int ixRow = 0; ixRow < dt.Rows.Count; ixRow++)
         {
            object o = dt.Rows[ixRow][0];
            result[ixRow] = convertFunc(o);
         }

         return result;
      }

      public static object[,] ConvertDataTableToExcelMatrix(DataTable dataTable, Func<DataColumn, object, object> convertFunc = null)
      {
         var result = new object[dataTable.Rows.Count + 1, dataTable.Columns.Count];

         int columnIndex = 0;
         foreach (DataColumn dataColumn in dataTable.Columns)
         {
            result[0, columnIndex] = dataColumn.ColumnName;
            columnIndex++;
         }

         int rowIndex = 1;
         foreach (DataRow dataRow in dataTable.Rows)
         {
            columnIndex = 0;
            foreach (DataColumn dataColumn in dataTable.Columns)
            {
               object value = dataRow[dataColumn];

               if (convertFunc == null)
               {
                  result[rowIndex, columnIndex] = value;
               }
               else
               {
                  result[rowIndex, columnIndex] = convertFunc(dataColumn, value);
               }

               columnIndex++;
            }

            rowIndex++;
         }

         return result;
      }
   }
}
