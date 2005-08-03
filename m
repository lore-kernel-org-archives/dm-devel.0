From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: Re: mirroring: [patch 1 of 6] device failure tolerance
Date: Wed, 3 Aug 2005 13:48:11 -0500
Message-ID: <e40538a1400cf18abec4993361441c00@redhat.com>
References: <9c5e9901e6e1e5f064cd64a5b855b503@redhat.com>
	<loom.20050803T173749-127@post.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <loom.20050803T173749-127@post.gmane.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

You're welcome to try them.  However, the user-space compliment for 
handling device failures is not there yet.  You should be able to test 
read balancing though.

Please make sure you have the latest patches.  See:
http://www.redhat.com/archives/dm-devel/2005-August/msg00006.html
and
http://www.redhat.com/archives/dm-devel/2005-August/msg00018.html

  brassow

On Aug 3, 2005, at 10:50 AM, Dick wrote:

> I'm really happy someone (Jonathan E Brassow) is working on this part 
> of
> device-mapper. I'd like to know if I can 'safely' try these patches, 
> or will it
> most likely nuke my data? I'm especially interested in the read 
> balancing
> updates with raid-1.
>
> Greetings,
> Dick
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
