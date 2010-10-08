From: nishant mungse <nishantmungse@gmail.com>
Subject: Problem regarding splitting and merging of bio's in dm
	target
Date: Fri, 8 Oct 2010 14:15:11 +0530
Message-ID: <AANLkTi=E87rswD7=kZXJXDCXLOFdvnie2kASOyAun71m@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6544886565784633891=="
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

--===============6544886565784633891==
Content-Type: multipart/alternative; boundary=20cf303b3c014df73b0492170714

--20cf303b3c014df73b0492170714
Content-Type: text/plain; charset=ISO-8859-1

I'm new to kernel coding and I have this doubt. I'm trying to write a
simple dm-target which will concatenate devices and perform io
operations on it.

There are a couple of things that I'm stuck up with......any help is
appreciated ...
hi all,


1. What do the presuspend and postsuspend fields in struct target_type mean
?

2. A bio request for read is split into no. of bios (here we're also
splitting bvec's wherever necessary) for reading from different
devices. For splitting the bvec's we are using the function split_bvec
(drivers/md/dm.c).
Now, after read completion, we've multiple bios with data in pages
pointed by bvec. For satisfying the read request, we want to merge the
data available in bios (Because we have splitted one bvec from
original bio into no. of bios).

How can we merge these bvec's into one bvec for original bio?
Does the function dm_merge_bvec (dm.c) serve the same purpose?

Thanks and Regards,
Nishant

--20cf303b3c014df73b0492170714
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I&#39;m new to kernel coding and I have this doubt. I&#39;m trying to write=
 a<br>simple dm-target which will concatenate devices and perform io<br>ope=
rations on it.<br><br>There are a couple of things that I&#39;m stuck up wi=
th......any help is<br>
appreciated ...<br>hi all,<br><br><br>1. What do the presuspend and postsus=
pend fields in struct target_type mean ?<br><br>2. A bio request for read i=
s split into no. of bios (here we&#39;re also<br>splitting bvec&#39;s where=
ver necessary) for reading from different<br>
devices. For splitting the bvec&#39;s we are using the function split_bvec<=
br>(drivers/md/dm.c).<br>Now, after read completion, we&#39;ve multiple bio=
s with data in pages<br>pointed by bvec. For satisfying the read request, w=
e want to merge the<br>
data available in bios (Because we have splitted one bvec from<br>original =
bio into no. of bios).<br><br>How can we merge these bvec&#39;s into one bv=
ec for original bio?<br>Does the function dm_merge_bvec (dm.c) serve the sa=
me purpose?<br>
<br>Thanks and Regards,<br>Nishant<br><br>

--20cf303b3c014df73b0492170714--


--===============6544886565784633891==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6544886565784633891==--
