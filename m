From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: add IV generation method null
Date: Thu, 1 Mar 2007 14:41:12 +0000
Message-ID: <20070301144112.GE3319@agk.surrey.redhat.com>
References: <20070216142112.GA924@suse.de> <20070228144754.GA24504@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070228144754.GA24504@suse.de>
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

On Wed, Feb 28, 2007 at 03:47:54PM +0100, Ludwig Nussel wrote:
> Any comments/objections on the patch? Is there any additional action
> from my side required to get this into the mainline kernel?

This comment ought to be more descriptive:

  null: For mounting legacy images only.


I'll include it in the next set of patches I send upstream.
 
Alasdair
-- 
agk@redhat.com
