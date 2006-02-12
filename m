From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: devmapper 1.02.03 breaks ABI
Date: Sun, 12 Feb 2006 20:38:14 +0000
Message-ID: <20060212203814.GX12169@agk.surrey.redhat.com>
References: <20060212102357.GA4134@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060212102357.GA4134@wavehammer.waldi.eu.org>
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

On Sun, Feb 12, 2006 at 11:23:57AM +0100, Bastian Blank wrote:
> devmapper 1.02.03 breaks the ABI by removing the exported symbol dm_strdup.
 
Indeed - 1.02.02 was a development release and there were some
problems with the interfaces after the code from LVM2 moved in.

I don't intend to export that function.  Parts of the 1.02 
interface are still subject to change: The part used in the 
RHEL4 U3 package (incl. dm_strdup_aux) is now frozen, but the 
dmeventd extensions will change further.

Alasdair
-- 
agk@redhat.com
