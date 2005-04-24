From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Fw: [Bugme-new] [Bug 4507] New: device-mapper crypt
	can't encrypt cdrom device
Date: Sun, 24 Apr 2005 22:05:01 +0100
Message-ID: <20050424210501.GF9049@agk.surrey.redhat.com>
References: <20050423175523.7aa0dd63.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050423175523.7aa0dd63.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hadmut@danisch.de
Cc: Andrew Morton <akpm@osdl.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Apr 23, 2005 at 05:55:23PM -0700, Andrew Morton wrote:
> I'm not sure if this is a bug or a user error.  Could someone please
> update the bugzilla record?
 
I'll get registered with it etc...

> # dmsetup create cdromx

I've never tried this with a cdrom, but I expect you'll at least 
need to make it read-only by adding -r.

Alasdair
-- 
agk@redhat.com
