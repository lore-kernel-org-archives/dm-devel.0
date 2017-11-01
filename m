From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Replacement for dm_dispatch_request for older
 request based targets
Date: Wed, 1 Nov 2017 12:08:57 -0400
Message-ID: <20171101160857.GA25886@redhat.com>
References: <BY2PR18MB03446D72103BA92941E3CF46C25F0@BY2PR18MB0344.namprd18.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <BY2PR18MB03446D72103BA92941E3CF46C25F0@BY2PR18MB0344.namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tariq Mustafa <tmustafa@hotmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 01 2017 at  2:23am -0400,
Tariq Mustafa <tmustafa@hotmail.com> wrote:

>    Hello,
> 
>    I am trying to figure out what would be the appropriate replacement for
>    "dm_dispatch_request()" on the newer kernel? This export has been removed
>    (by commit - [1][dbf978]), what would be an equivalent call to submit the
>    request.

dm_dispatch_request was renamed to dm_dispatch_clone_request (IIRC).

But are you asking what is the new export?  There isn't one.  There
should be no need for anything other than DM core (dm-rq.c) to call
these interfaces that are no longer exported.

Please explain what you're trying to do if you need more help.

Thanks,
Mike
