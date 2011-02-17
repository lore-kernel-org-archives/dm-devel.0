From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Improving dm-mirror as a final year project
Date: Thu, 17 Feb 2011 15:02:04 -0600
Message-ID: <D19C1F43-C452-4F3C-9975-1A11680724D1@redhat.com>
References: <20110125155342.GG26864@genesis.frugalware.org>
	<63C70D40-54EE-40A2-98B9-82E06A956941@redhat.com>
	<20110214173352.GJ5980@genesis.frugalware.org>
	<2D45663B-1CE9-4266-97FF-C2C6A959EA64@redhat.com>
	<20110215125214.GR5980@genesis.frugalware.org>
	<1DF24E8A-B258-4F95-BE8D-15C8EB311748@redhat.com>
	<20110216171219.GA5980@genesis.frugalware.org>
	<20110217104926.GG5980@genesis.frugalware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110217104926.GG5980@genesis.frugalware.org>
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


On Feb 17, 2011, at 4:49 AM, Miklos Vajna wrote:

> On Wed, Feb 16, 2011 at 06:12:19PM +0100, Miklos Vajna  
> <vmiklos@ulx.hu> wrote:
>>> The basic component that covers RAID456 is available upstream, as  
>>> you
>>> saw.  I have an additional set of ~12 (reasonably small) patches  
>>> that
>>> add RAID1 and superblock/bitmap support.  These patches are not yet
>>> upstream nor are they in any RHEL product.
>>
>> Then what is the recommended platform to hack dm-raid? I have RHEL6  
>> at
>> the moment. Is it OK to try to cherry-pick the single commit from
>> upstream + apply your patches or is it better to install rawhide  
>> where
>> the kernel is already 2.6.38rc5 (as far as I see) and only apply your
>> patches there?

I tend to use RHEL6 + the latest upstream kernel.  I would /not/  
cherry-pick the upstream dm-raid patch and then add my next set - you  
might miss some other valuable MD patches (there have been a couple).

>>
>>> For convenience, I've attached the patches I'm working on (quilt
>>> directory) and the latest gime_raid.pl script.
>
> I tried these on Fedora 15 with mixed results.
>
> I prepared a kernel source tree:
>
> ----
> $ wget http://download.fedora.redhat.com/pub/fedora/linux/development/15/source/SRPMS/kernel-2.6.38-0.rc4.git0.2.fc15.src.rpm

Please use upstream (kernel.org) kernel.

Contact me with any trouble.

  brassow
