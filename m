From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: devmap_name
Date: Mon, 21 Feb 2005 14:18:39 +0000
Message-ID: <20050221141839.GF14093@agk.surrey.redhat.com>
References: <421922F0.9010309@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <421922F0.9010309@free.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 21, 2005 at 12:53:20AM +0100, christophe varoqui wrote:
> would you be interested in merging devmap_name functionnality in dmsetup ?
> For background, "devmap_name $major $minor" throw back the associated 
> devmap name.
 
> I can code up a patch to do the same with "dmsetup ls [-j|--major 
> <major>] [-m|--minor <minor>]" ...
 
I already did in 1.00.20.  Try it:-)
And the kernel interface now accepts major+minor as an alternative to name 
or uuid for referencing an existing device.

Alasdair
-- 
agk@redhat.com
