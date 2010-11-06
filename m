From: Lars Marowsky-Bree <lmb@novell.com>
Subject: Re: RFC: multipath IO multiplex
Date: Sat, 6 Nov 2010 18:03:38 +0100
Message-ID: <20101106170338.GF30809@suse.de>
References: <20101105183946.GG25992@suse.de> <20101106053203.7e4ef435@notabene>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101106053203.7e4ef435@notabene>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2010-11-06T05:32:03, Neil Brown <neilb@suse.de> wrote:

> Hi Lars,
>  the only issue that occurs to me is that if you want to report the first
>  success, then you need to copy the data to a private buffer before
>  submitting the write.  Then wait for all writes to complete before freei=
ng
>  the buffer.  If you just return the first write the page would be unlock=
ed
>  and so could be changed will another path was still writing it out.

Right. This is, in a way, a mix of MPIO / RAID1 handling. We'd indeed
need to have the write block several times - thankfully, we write really
rarely and only one sector at a time, so the memory consumption is
trivial.

(However, we _really_ want to get those writes to disk. Right away.)

>  Finding a way to signal 'write all paths sounds tricky.  This flag needs=
 to
>  be state of the filedescriptor, not the whole device, so it would need t=
o be
>  an fcntl rather than an ioctl.  And defining new fcntls is a lot harder
>  because they need to be more generic - you cannot really make them device
>  specific...
>  Might it make sense to configure a range of the device where writes alwa=
ys
>  went down all paths?  That would seem to fit with your problem descripti=
on
>  and might be easiest??

Technically, it'd be possible, because that section is contiguous on
the disk, yes.

(Note that we don't open a real file in a file system, but use a raw
block device; however, that could be a partition on top of MPIO.)

But I'm a bit unclear how we'd define that; clearly, we don't want to
by-pass multipathd management of the MPIO mapping, that being the whole
point why we don't just handle that in user-space ;-)

Hrm. I already have a dm-linear mapping (thanks to kpartx; otherwise
it's trivially introduced). I could modify that to include a special
flag that would mangle the bios that pass through - so I could set a bio
flag that multipath could then act on ...?

(There's precedent; the failfast bio flag.)


Regards,
    Lars

-- =

Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
