From: Steve Powell <rspowell@us.ibm.com>
Subject: clvmd "broken" after device-mapper up2date
Date: Tue, 25 Apr 2006 15:41:07 -0400
Message-ID: <OF7E76BA5F.FEAC8AAF-ON8625715B.006B53A4-8525715B.006C2293@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0236155355=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multipart message in MIME format.
--===============0236155355==
Content-Type: multipart/alternative;
	boundary="=_alternative 006C22928525715B_="

This is a multipart message in MIME format.
--=_alternative 006C22928525715B_=
Content-Type: text/plain; charset="US-ASCII"

I have two servers running RedHat AS 4. Below is a table showing versions 
of software:

Server1                         Server2
update 2                        update 3
device-mapper.1.02.02           device-mapper-1.01.04
lvm2.2.01.12                    lvm2.2.02.01
GFS-6.1.2                       GFS-6.1.2


When server 2 was upgrade to the new versions, clvmd would no longer 
start; I recevied the error message: 

/usr/sbin/vgchange: symbol lookup error: /usr/lib64/liblvm2clusterlock.so: 
undefined symbol: malloc_aux

With these servers being clustered, do both have to be at the same rev for 
all these packages? If Iupgrade server #1, will I break GFS there?

Is there a DM command I can run that will restore the original VG/LV/PVs?





--=_alternative 006C22928525715B_=
Content-Type: text/html; charset="US-ASCII"


<br><font size=2 face="sans-serif">I have two servers running RedHat AS
4. Below is a table showing versions of software:</font>
<br>
<br><font size=2 face="sans-serif"><u>Server1 &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp;Server2</u></font>
<br><font size=2 face="sans-serif">update 2 &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;update
3</font>
<br><font size=2 face="sans-serif">device-mapper.1.02.02 &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;device-mapper-1.01.04</font>
<br><font size=2 face="sans-serif">lvm2.2.01.12 &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;lvm2.2.02.01</font>
<br><font size=2 face="sans-serif">GFS-6.1.2 &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;GFS-6.1.2</font>
<br>
<br>
<br><font size=2 face="sans-serif">When server 2 was upgrade to the new
versions, clvmd would no longer start; I recevied the error message: </font>
<br>
<br><font size=2 face="sans-serif">/usr/sbin/vgchange: symbol lookup error:
/usr/lib64/liblvm2clusterlock.so: undefined symbol: malloc_aux</font>
<br>
<br><font size=2 face="sans-serif">With these servers being clustered,
do both have to be at the same rev for all these packages? If Iupgrade
server #1, will I break GFS there?</font>
<br>
<br><font size=2 face="sans-serif">Is there a DM command I can run that
will restore the original VG/LV/PVs?</font>
<br>
<br>
<br>
<br>
<br>
--=_alternative 006C22928525715B_=--


--===============0236155355==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0236155355==--
