From: Jim Meyering <jim-Oxw1nKZkIVjk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [ovirt-devel] blockdev --flushbufs required [was:
	parted issue/question
Date: Thu, 19 Jan 2012 14:00:45 +0100
Message-ID: <871uqvkfsy.fsf@rho.meyering.net>
References: <4F13ADB3.5070806@redhat.com> <87lip6t157.fsf@rho.meyering.net>
	<20120118003802.GA11769@agk-dp.fab.redhat.com>
	<87haztruph.fsf_-_@rho.meyering.net>
	<1326895081.27879.0.camel@beelzebub.mburnsfire.net>
	<CAGi==UV2RXGzpxtKa4_4JWqdWrMP6_pf_PrdyDMtjMmSQtXgPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <node-devel-bounces-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <CAGi==UV2RXGzpxtKa4_4JWqdWrMP6_pf_PrdyDMtjMmSQtXgPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Alan Pevec's message of "Wed, 18 Jan 2012 17:22:14 +0100")
List-Unsubscribe: <http://lists.ovirt.org/mailman/options/node-devel>,
	<mailto:node-devel-request-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.ovirt.org/pipermail/node-devel/>
List-Post: <mailto:node-devel-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:node-devel-request-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <http://lists.ovirt.org/mailman/listinfo/node-devel>,
	<mailto:node-devel-request-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: node-devel-bounces-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org
Errors-To: node-devel-bounces-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org
To: Alan Pevec <apevec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Burns <mburns-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, node-devel <node-devel-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org>
List-Id: dm-devel.ids

Alan Pevec wrote:

>> On Wed, 2012-01-18 at 14:44 +0100, Jim Meyering wrote:
>>> [Following up on this thread:
>>> =A0http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/14999]
>>> Alasdair G Kergon wrote:
>>> > Try
>>> > =A0 blkdev --flushbufs
>>> > after any cmd that writes to a dev to see if that makes any differenc=
e.
>>>
>>> Thanks for the work-around.
>>> Using "blockdev --flushbufs $dev" does indeed make parted
>>> behave the same with dm-backed storage as with other devices.
>
> Thanks Jim!
> That reminds me we've already seen something similar and there's still
> workaround with drop_caches in ovirt-config-boot installer:
>             # flush to sync DM and blockdev, workaround from rhbz#623846#=
c14
>             echo 3 > /proc/sys/vm/drop_caches
>
> But 623846 was supposed to be fixed in RHEL 6.0 ?

FYI, Niels de Vos has just posted a patch that should fix this:

  http://thread.gmane.org/gmane.linux.kernel/1241227

With that, maybe you'll be able to remove that other work-around.
