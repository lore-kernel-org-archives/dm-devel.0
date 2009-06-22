From: Wes Felter <wesley@felter.org>
Subject: Re: A simple, generic DM-API,
	for codecs/transcoders to use?
Date: Mon, 22 Jun 2009 18:13:48 -0500
Message-ID: <h1p37d$s0t$1@ger.gmane.org>
References: <49C0B79A.9010601@googlemail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49C0B79A.9010601@googlemail.com>
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

Navid Zamani wrote:
> Hello DM mailing list.
> 
> I a have a simple question:
> Is there a way to use the device-mapper to hang an arbitrary program
> in-between a real block device, and the virtual device created by the
> device-mapper?

http://static.danplanet.com/dm-userspace/

> In case you are interested in the reasons: Modern consumer HDDs do not
> have any ECC, but they get less and less reliable.

I don't think this is correct. All disks use ECC; cheap disks just don't 
use strong enough ECC. 4K sectors may fix this in the distant future.

> So I decided to put my whole archive on a partititon with software-based
> ECC. And because I could not find something that resembled this, I chose
> to implement it myself.

Honestly I would use RAID + Btrfs instead of software ECC. But if you're 
determined to go down this path, you may want to investigate LDPC 
instead of RS.

Wes Felter - wesley@felter.org
