From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 0/7] dm-mpath: Fix a race condition in the
 blk-mq path
Date: Tue, 15 Nov 2016 17:10:16 -0800
Message-ID: <37cbd516-da2a-7532-8231-3ae5d2e4caf8@sandisk.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<20161116004752.GD19059@redhat.com>
	<51cae932-470e-aa27-8c7d-e33ed978f37e@sandisk.com>
	<20161116010802.GF19059@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161116010802.GF19059@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/15/2016 05:08 PM, Mike Snitzer wrote:
> I'm getting very tired of this.  Last I knew those tests pass.  Do you
> keep changing the tests or something?

If the dm code would work reliably I wouldn't have to post any dm 
patches. The only factor that I changed is the number of test iterations 
I ran.

Bart.
