From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: create lvm2 snapshot will take a long time while
 large IO on origin lv(till large IO ends)
Date: Thu, 29 Apr 2010 13:31:16 -0400
Message-ID: <4BD9C264.7040501@cfl.rr.com>
References: <w2ub8091bb41004282024i9ae427f7gf963baab82d811d0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <w2ub8091bb41004282024i9ae427f7gf963baab82d811d0@mail.gmail.com>
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
Cc: Busby <chaimvy@gmail.com>
List-Id: dm-devel.ids

On 4/28/2010 11:24 PM, Busby wrote:
> it seems the vgs suspend because the lvcreate cmd don't unlock the
> flock, but why the lvcreating of snapshot lv will be suspended while the
> origin is on big data IO?

Because when creating a snapshot it tries to flush any dirty buffers so
that the origin is in a consistent state at the time the snapshot is
created.  This is done to minimize the chance that the filesystem on the
snapshot will be corrupt.
