
package model;

public class ThongKe {
   private String ngayTaoHoaDon ;
   private double TongTien ;

    public ThongKe() {
    }

    public ThongKe(String ngayTaoHoaDon, double TongTien) {
        this.ngayTaoHoaDon = ngayTaoHoaDon;
        this.TongTien = TongTien;
    }

    public String getNgayTaoHoaDon() {
        return ngayTaoHoaDon;
    }

    public void setNgayTaoHoaDon(String ngayTaoHoaDon) {
        this.ngayTaoHoaDon = ngayTaoHoaDon;
    }

    public double getTongTien() {
        return TongTien;
    }

    public void setTongTien(double TongTien) {
        this.TongTien = TongTien;
    }
   
    
   
}
