From: zhiming shen <zhiming.shim@gmail.com>
Subject: does file system page cache work after device mapping?
Date: Tue, 22 May 2012 15:18:42 -0400
Message-ID: <CAEEE0xjZ2H4vAFpQqKhY+VvV6V3EXow-Wk_4hUuT_e+r0OMU7Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0856913418753602054=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============0856913418753602054==
Content-Type: multipart/alternative; boundary=e89a8f3ba1170277f304c0a4e315

--e89a8f3ba1170277f304c0a4e315
Content-Type: text/plain; charset=ISO-8859-1

Hi everyone, I have some questions regarding to the mechanism of device
mapper: After the device mapper layer gets the mapping information, it will
issue IO request to the real device. How does it perform IO operation at
this stage? For example, if the device is a block device, will it go to the
page cache and check whether the desired block is in cache? If the block is
not in cache and it read from the physical device, will the block be cached
in memory?

Thanks very much!


Zhiming

--e89a8f3ba1170277f304c0a4e315
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi everyone, I have some questions regarding to the mechanism of device map=
per: After the device mapper layer gets the mapping information, it will is=
sue IO request to the real device. How does it perform IO operation at this=
 stage? For example, if the device is a block device, will it go to the pag=
e cache and check whether the desired block is in cache? If the block is no=
t in cache and it read from the physical device, will the block be cached i=
n memory? <br>
<br>Thanks very much!<br><br><br>Zhiming<br>

--e89a8f3ba1170277f304c0a4e315--


--===============0856913418753602054==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0856913418753602054==--
