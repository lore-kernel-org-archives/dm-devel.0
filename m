From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 0/4][RFC] dm-core: full barrier support
Date: Mon, 12 Jan 2009 14:01:16 +0100
Message-ID: <496B3F1C.6050709@redhat.com>
References: <4966260C.6070602@redhat.com>
	<Pine.LNX.4.64.0901111319240.25677@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0901111319240.25677@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mikulas Patocka wrote:
> I looked at the patches.

Thanks - the patchset was meant more like impulse to start discussion:-)

This implementation uses just simple idea to reuse dm suspend mechanism
for barrier processing.

> I have thought about it and written an implementation of asynchronous 
> barriers --- it works by passing the requests to kdmflush and it returns 
> immediatelly from dm_request. I'll post it in a few days.

Great. I'll wait for the patches then:)

The internal thread was added to DM devices mainly because of implementing
barriers but this intention was never finished...

Milan
--
mbroz@redhat.com
