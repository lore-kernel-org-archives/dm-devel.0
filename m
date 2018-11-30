From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 0/2] dm kcopyd: dm snapshot: Fix bugs causing
 excessive memory usage and workqueue stalls
Date: Fri, 30 Nov 2018 19:53:23 +0200
Message-ID: <8eccbec5-87a9-17d5-3ffa-eba272f5c7c5@arrikto.com>
References: <20181031215309.6493-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181031215309.6493-1-ntsironis@arrikto.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, iliastsi@arrikto.com
List-Id: dm-devel.ids

Hello!

This is a kind reminder for these two patches. They seem to be fixing
two bugs (one of them an OOM condition), so I'm bumping this thread to
solicit your feedback.

I'm also Cc:ing mpatocka@redhat.com. Mikulas, this must be your area of
expertise, based on past commit history, so I'm adding an explicit Cc:
to make sure this doesn't slip through the cracks.

Looking forward to your feedback,

Nikos
