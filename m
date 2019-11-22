From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: multipath - unable to use multiple active paths at once,
 and deprecated example in docs
Date: Fri, 22 Nov 2019 13:27:04 -0700
Message-ID: <CAN-y+EJOt=MRDEXCx9_U4zmDs+i9yXj364E4+z=xC=u8+Ao1PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2426868199381452598=="
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

--===============2426868199381452598==
Content-Type: multipart/alternative; boundary="0000000000005630f60597f53dff"

--0000000000005630f60597f53dff
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

My use case doesn't lend itself well to multipathd, so I'm trying to
implement multipathing with device mapper directly.

My table is (kernel 4.19.79):

0 1562378240 multipath 4 queue_if_no_path retain_attached_hw_handler
queue_mode bio 0 1 1 queue-length 0 4 1 253:11 1 253:8 1 253:9 1 253:10 1

What I've found with this setup is that, aside from the first path in the
group, none of the other paths receive IO/bios.

The only "real" path is 253:11, the rest of them are to dm error targets.
Still though, you can see the status of this multipath target is:

0 1562378240 multipath 2 0 0 0 1 1 A 0 4 1 253:11 A 0 309 253:8 A 0 0 253:9
A 0 0 253:10 A 0 0

So 253:11 has a queue of 309, while the rest of the devices have a queue of
zero and show an active status, indicating no IO has triggered the
underlying dm error target causing the 2nd, 3rd, and 4th paths to fail.

Before diving much deeper into the relevant kernel code, I figured I'd
check to see if there's any obvious reason this should not work the way I
expect (where individual paths are balanced within the group).

I realize that Documentation/device-mapper/dm-queue-length.txt is also
out-dated (it makes suggestions that are deprecated), but still that
documentation implies this table would balance the load. Here is the table
from those docs.

test: 0 10 multipath 0 0 1 1 queue-length 0 2 1 8:0 128 8:16 128 ( >1 is
deprecated since those docs)

My only assumption is that the multipath features, in particular queue_mode
bio, prevent this from behaving properly. If that is the case, why can this
not be achieved with bios, as this is not a limitation of raid1 (which will
load balance read IO to device mapper targets). I also believe this is the
only feature option that is viable for me, since this multipath device is
on top of device mapper targets.

The documentation would imply that the queue should be roughly the same to
every device, and that after every IO a new path is chosen for the next IO
based on the lowest entry. The code looks like it does this as described,
but maybe there's some condition preventing it from doing so (while still
counting the queue). Is there anything I can do to get this target to
behave as I assumed it would from
Documentation/device-mapper/dm-queue-length.txt ?

Also, for what it's worth, round-robin behaves the same way as queue-length=
.

Thank you for your time!
- Drew

--0000000000005630f60597f53dff
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">My use case doesn&#39;t lend itself well to multipathd, so=
 I&#39;m trying to implement multipathing with device mapper directly.<br><=
br>My table is (kernel 4.19.79):<br><br>0 1562378240 multipath 4 queue_if_n=
o_path retain_attached_hw_handler queue_mode bio 0 1 1 queue-length 0 4 1 2=
53:11 1 253:8 1 253:9 1 253:10 1<br><br>What I&#39;ve found with this setup=
 is that, aside from the first path in the group, none of the other paths r=
eceive IO/bios.<br><br>The only &quot;real&quot; path is 253:11, the rest o=
f them are to dm error targets. Still though, you can see the status of thi=
s multipath target is:<br><br>0 1562378240 multipath 2 0 0 0 1 1 A 0 4 1 25=
3:11 A 0 309 253:8 A 0 0 253:9 A 0 0 253:10 A 0 0 <br><br>So 253:11 has a q=
ueue of 309, while the rest of the devices have a queue of zero and show an=
 active status, indicating no IO has triggered the underlying dm error targ=
et causing the 2nd, 3rd, and 4th paths to fail.<br><br>Before diving much d=
eeper into the relevant kernel code, I figured I&#39;d check to see if ther=
e&#39;s any obvious reason this should not work the way I expect (where ind=
ividual paths are balanced within the group).<br><br>I realize that Documen=
tation/device-mapper/dm-queue-length.txt is also out-dated (it makes sugges=
tions that are deprecated), but still that documentation implies this table=
 would balance the load. Here is the table from those docs.<br><br>test: 0 =
10 multipath 0 0 1 1 queue-length 0 2 1 8:0 128 8:16 128 ( &gt;1 is depreca=
ted since those docs)<br><br>My only assumption is that the multipath featu=
res, in particular queue_mode bio, prevent this from behaving properly. If =
that is the case, why can this not be achieved with bios, as this is not a =
limitation of raid1 (which will load balance read IO to device mapper targe=
ts). I also believe this is the only feature option that is viable for me, =
since this multipath device is on top of device mapper targets.<br><br>The =
documentation would imply that the queue should be roughly the same to ever=
y device, and that after every IO a new path is chosen for the next IO base=
d on the lowest entry. The code looks like it does this as described, but m=
aybe there&#39;s some condition preventing it from doing so (while still co=
unting the queue). Is there anything I can do to get this target to behave =
as I assumed it would from Documentation/device-mapper/dm-queue-length.txt =
?<br><br>Also, for what it&#39;s worth, round-robin behaves the same way as=
 queue-length.<br><br>Thank you for your time!<br>- Drew</div>

--0000000000005630f60597f53dff--

--===============2426868199381452598==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2426868199381452598==--
