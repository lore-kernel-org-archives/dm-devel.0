From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: dm-cache suspend semantics
Date: Wed, 19 Aug 2015 12:26:20 +0100
Message-ID: <CAM2wQBsvnY+eBMxEFRy07f=16XnYmcdVQOewo-DWBseSnqAR9g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: heinzm@redhat.com, thornber@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

I'd like to know whether it is possible for a cache target for which
there are dirty blocks to continue writing back dirty data after it
has been suspended. Can this happen? I checked the code and
cache_postsuspend() suggests that after the target is suspended no
write back I/O will be initiated (I also did a quick test that
confirms this), however I'd appreciate an answer from the maintainers
as I might have misunderstood.

-- 
Thanos Makatos
