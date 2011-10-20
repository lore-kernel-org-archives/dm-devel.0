From: Joe Thornber <thornber@redhat.com>
Subject: Re: your mail
Date: Thu, 20 Oct 2011 10:52:15 +0100
Message-ID: <20111020095214.GA4680@ubuntu>
References: <Pine.LNX.4.64.1110192014570.24440@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110192014570.24440@hs20-bc2-1.build.redhat.com>
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

On Wed, Oct 19, 2011 at 08:17:37PM -0400, Mikulas Patocka wrote:
> Hi
> 
> Here I'm sending two dm-bufio patches. The first one fixed 
> dm_bufio_release_move function (the write callback could be called with a 
> wrong block number). The next one adds a conditional resched (Alasdair 
> agreed on it --- it should be later put into general Linux headers).

Thanks Mikulas, merging now.

- Joe
