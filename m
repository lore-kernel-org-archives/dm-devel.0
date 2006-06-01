From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: HOW to install software to mapped device persistently
Date: Thu, 1 Jun 2006 15:07:03 +0100
Message-ID: <20060601140703.GK10603@agk.surrey.redhat.com>
References: <optago9tmrbp19rg@devel.lan.internet2.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <optago9tmrbp19rg@devel.lan.internet2.ru>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: vlkukushkin@yandex.ru
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 01, 2006 at 02:11:43PM +0400, V.Kukushkin wrote:
> All we know the good way to make read-only ROOT device be read-write  
> looking.
> It is the use of dmsetup in initrd. It works perfect. But ..
 
Depends where the 'read-only' setting is coming from.

LVM?  Use lvchange -pr

dm itself?  (using device vg0-lvol0 as the example)
  'dmsetup info vg0-lvol0 | grep State' shows ACTIVE (READ-ONLY)

Then:
  dmsetup table vg0-lvol0 | dmsetup reload vg0-lvol0; dmsetup resume vg0-lvol0
And to put it back read-only afterwards
  dmsetup table vg0-lvol0 | dmsetup reload -r vg0-lvol0; dmsetup resume vg0-lvol0

Alasdair
-- 
agk@redhat.com
