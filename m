From: "Larry Dickson" <ldickson@cuttedge.com>
Subject: Re: [PATCH 0/3] freeze feature ver 1.6
Date: Wed, 25 Jun 2008 14:45:55 -0700
Message-ID: <1c748a490806251445x4c1f4901nb503273b08dd680@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0639661390=="
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

--===============0639661390==
Content-Type: multipart/alternative;
	boundary="----=_Part_628_12704449.1214430355661"

------=_Part_628_12704449.1214430355661
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

I just signed up for dm-devel, so I don't know if this will get posted; but
it looks like this freeze feature may answer a need of mine. Could one of
you tell me if I'm on the right track?

Over an LVM volume is mounted a file system that gets a lot of streaming
writes, and has been set up so that almost all access is sequential, with
data coming out of big FIFO caches. But readers may want access to the
existing files. If too many readers try to access, it will cause lots of
seeks and slow down the write access enough to cause data loss, which is not
OK. I can see this coming by noticing that the FIFOs are filling up.

What I need is to freeze read access when this happens, but permit write
access to continue. Then the seeks stop happening, and the FIFOs drain.
After they have reached a certain point, I unfreeze read access; so the
(probably NFS) readers may see slowness and jerkiness, but their stuff runs.

Can this freeze feature do that? I was thinking of working an XON/XOFF
through the proc file system, and patching in some special code of my own,
but it would be much nicer if it were more standard.

Larry Dickson
Cutting Edge Networked Storage

------=_Part_628_12704449.1214430355661
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div>Hi all,</div>
<div>&nbsp;</div>
<div>I just signed up for dm-devel, so I don&#39;t know if this will get posted; but it looks like this freeze feature may answer a need of mine. Could one of you tell me if I&#39;m on the right track?</div>
<div>&nbsp;</div>
<div>Over an LVM volume is mounted a file system that gets a lot of streaming writes, and has been set up so that almost all access is sequential, with data coming out of big FIFO caches. But readers may want access to the existing files. If too many readers try to access, it will cause lots of seeks and slow down the write access enough to cause data loss, which is not OK. I can&nbsp;see this coming&nbsp;by noticing that the FIFOs are filling up.</div>

<div>&nbsp;</div>
<div>What I need is to freeze read access when this happens, but permit write access to continue. Then the seeks stop happening, and the FIFOs drain. After they have reached a certain point, I unfreeze read access; so the (probably NFS) readers may see slowness and jerkiness, but their stuff runs.</div>

<div>&nbsp;</div>
<div>Can this freeze feature do that? I was thinking of working an XON/XOFF through the proc file system, and patching in some special code of my own, but it would be much nicer if it were more standard.</div>
<div>&nbsp;</div>
<div>Larry Dickson</div>
<div>Cutting Edge Networked Storage</div>

------=_Part_628_12704449.1214430355661--


--===============0639661390==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0639661390==--
