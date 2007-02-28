From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: add IV generation method null
Date: Wed, 28 Feb 2007 15:47:54 +0100
Message-ID: <20070228144754.GA24504@suse.de>
References: <20070216142112.GA924@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070216142112.GA924@suse.de>
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

Ludwig Nussel wrote:
> Following patch (against SUSE's 2.6.18) adds the IV generation
> method 'null' to be able to read old filesystem images created with
> SuSE's loop_fish2 module.

Any comments/objections on the patch? Is there any additional action
from my side required to get this into the mainline kernel?

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   SUSE Labs
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
