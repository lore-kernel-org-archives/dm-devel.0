From: Miklos Vajna <vmiklos@ulx.hu>
Subject: Re: Improving dm-mirror as a final year project
Date: Wed, 16 Feb 2011 18:12:19 +0100
Message-ID: <20110216171219.GA5980@genesis.frugalware.org>
References: <20110125155342.GG26864@genesis.frugalware.org>
	<63C70D40-54EE-40A2-98B9-82E06A956941@redhat.com>
	<20110214173352.GJ5980@genesis.frugalware.org>
	<2D45663B-1CE9-4266-97FF-C2C6A959EA64@redhat.com>
	<20110215125214.GR5980@genesis.frugalware.org>
	<1DF24E8A-B258-4F95-BE8D-15C8EB311748@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1DF24E8A-B258-4F95-BE8D-15C8EB311748@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 15, 2011 at 04:13:15PM -0600, Jonathan Brassow <jbrassow@redhat.com> wrote:
> > Oh, do I read the code correctly that rhel6/upstream always reads from
> > the first mirror and switches only in case there is a read failure?
> 
> yes

Hm, was the was reason for dropping the round robin feature? I thought
that round robin causes better performance, given that IO reads are done
in an async way. Did I miss something or just nobody ported the patch to
RHEL6/upstream?

> Perhaps, but if you don't encode this in the LVM metadata, you will  
> have to perform the action every time you reboot.  Instead, you could  
> reorder the devices in userspace and reload the table.

I was not aware such a reorder is possible. That patch then does not
make too much sense, agreed. ;) (Do you have a pointer to some
documentation on how that reorder can be done? I can't find anything
about reorder in the lvconvert/dmsetup manpage.

> The basic component that covers RAID456 is available upstream, as you  
> saw.  I have an additional set of ~12 (reasonably small) patches that  
> add RAID1 and superblock/bitmap support.  These patches are not yet  
> upstream nor are they in any RHEL product.

Then what is the recommended platform to hack dm-raid? I have RHEL6 at
the moment. Is it OK to try to cherry-pick the single commit from
upstream + apply your patches or is it better to install rawhide where
the kernel is already 2.6.38rc5 (as far as I see) and only apply your
patches there?

> Yes, I have a script called 'gime_raid.pl' that creates the device- 
> mapper tables for dm-raid.  Eventually, this will be pushed into LVM,  
> but it was much easier (for testing purposes) to start with a perl  
> script.

Sure. :)

> For convenience, I've attached the patches I'm working on (quilt  
> directory) and the latest gime_raid.pl script.

Thanks!
