From: nick <xerofoify@gmail.com>
Subject: Re: [PATCH RESEND] md:Remove no longer needed fix me
 comment in dm-region-hash.c for removing the structure pointer,
 *rh from the definiton of dm_region
Date: Tue, 20 Jan 2015 06:36:10 -0500
Message-ID: <54BE3DAA.5080900@gmail.com>
References: <1421723781-21984-1-git-send-email-xerofoify@gmail.com>
	<20150120111951.GB17599@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150120111951.GB17599@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

Alasdair,
Unless we use a union or something similar there seems to be no easy 
way without rewriting a lot of an already function driver file.
Cheers,
Nick

On 2015-01-20 06:19 AM, Alasdair G Kergon wrote:
> On Mon, Jan 19, 2015 at 10:16:21PM -0500, Nicholas Krause wrote:
>> Removes the no longer needed fix me comment questioning if we need to remove
>> the structure pointer,rh as defined as a structure of type dsm_region_hash
>> from the definition of the structure, dm_region. Furthermore this  pointer is
>> needed in order for various functions to run and build successfully in the file,
>> dm-region-hash.c.
>  
> You've misunderstood the comment!
> Is there a better alternative to having every dm_region struct store its own copy of
> this pointer?
> 
> Alasdair
> 
