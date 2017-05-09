From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [mdadm PATCH] Create: tell udev md device is not
 ready when first created.
Date: Tue, 9 May 2017 14:14:33 +0200
Message-ID: <2461f05a-d742-dfc9-6e94-d3600cb99f93@redhat.com>
References: <149265560315.31004.3851231165281498425.stgit@noble>
	<149265600601.31004.323865505557190368.stgit@noble>
	<dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
	<87mvbasqx6.fsf@notabene.neil.brown.name>
	<40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
	<87h919ruj5.fsf@notabene.neil.brown.name>
	<6bd347e1-170c-48e9-1171-09ff143ace83@redhat.com>
	<c5fe5d16-5ca6-94b0-fd5b-0b6009d78bab@gmail.com>
	<2f431da6-0dce-b485-4109-6f8669814430@redhat.com>
	<590DF8FA.4090600@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <590DF8FA.4090600@youngman.org.uk>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wols Lists <antlists@youngman.org.uk>, Jes Sorensen <jes.sorensen@gmail.com>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/06/2017 06:25 PM, Wols Lists wrote:
> On 03/05/17 15:13, Peter Rajnoha wrote:
>> There's a difference though - when you're *creating* a completely new
>> device that is an abstraction over existing devices, you (most of the
>> time) expect that new device to be initialized. For those corner cases
>> where people do need to keep the old data, there can be an option to do
>> that.
> 
> That's not a corner case. If there's old data that's the NORM. I get
> what you're after, I'm inclined to agree with you, but the default
> should be to DO NOTHING.
> 
> If you want mdadm to mess about with the content of the drives you
> should either (a) explicitly tell it to (yes I would like that option
> :-), or (b) do it yourself beforehand - dd if=/dev/zero etc etc.

As for (b), the "dd" with zeroing all the future mdadm components I'm
going to use for an MD device is quite time-consuming operation, mainly
for large devices.

And we don't need to do that full zeroing at all, what I'm after is to
have the wipefs-like functionality directly integrated into mdadm (that
functionality is already a part of libbblkid and it's very easy to use
it as a matter of fact). With this, we can detect and wipe all
signatures that blkid detects. The blkid is used as a primary source of
information when processing uevents to decide about further processing.
Once we wipe all that blkid can see, we make the device clear for udev
processing too and we don't end up automatically activating some old
garbage that we don't intend to actually based on these uevent hooks.

-- 
Peter
