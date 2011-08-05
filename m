From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin: commit metadata bug
Date: Fri, 5 Aug 2011 14:13:39 +0100
Message-ID: <20110805131338.GA1882@ubuntu>
References: <Pine.LNX.4.64.1108050856100.19545@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108050856100.19545@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 05, 2011 at 08:59:09AM -0400, Mikulas Patocka wrote:
> There is a bug in committing metadata --- you can't commit metadata if 
> there is any copying or zeroing in flight. The problem is that in this 
> case, the block you are copying to is already allocated, but it is not 
> linked anywhere in the metadata. So it creates lost blocks in case of 
> crash.

Yes, well known and documented.  We take this hit, fsck will repair.

- Joe
