From: Joe Thornber <thornber@redhat.com>
Subject: Re: question: deleting blocks
Date: Tue, 16 Aug 2011 10:28:03 +0100
Message-ID: <20110816092802.GC4284@ubuntu>
References: <Pine.LNX.4.64.1108151426190.18170@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108151426190.18170@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Aug 15, 2011 at 02:27:56PM -0400, Mikulas Patocka wrote:
> BTW.
> 
> When you delete a block in the space map, how do you make sure that the 
> block is not allocated for another purpose before commit?

For the metadata-space-map I allocate from the space map as it was in
the last transaction (smm->old_ll).  The data space map needs to do
the same (for some reason I thought we could get away without it for a
while) - it's on the todo list in multisnap.org and was mentioned
yesterday.

- Joe
