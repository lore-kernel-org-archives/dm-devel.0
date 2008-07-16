From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: persistent reservation behaviour with dm-multipath
Date: Thu, 17 Jul 2008 00:01:11 +0200
Message-ID: <1216245671.28212.29.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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

The current dm-multipath behaviour is currently a potent data corrupter
on PR-based clusters sharing multipaths with the queue_if_no_path
feature on. Consider the following scenario :

- Node A take a write-exclusive persistent reservation on LU
- Node B submits a write io to LU, which is a sda-sdb multipath
=EF=BB=BF- B dm_multipath routes the wio to sda, the wio is failed, the p=
ath is
marked failed
=EF=BB=BF- B dm_multipath routes the wio to sdb, the wio is failed, the l=
ast
path is marked failed
- B queues the wio because of the queue_if_no_path feature. Process
submitting the wio is stuck in D-state.
- A releases the reservation. Queued wios are unqueued, corrupting the
data on LU.

I suspect wio returning a "reservation conflict" status should never be
queued.

DM suspend/resume on the multipath effectively flushes the queue, but
this solution leaves a window open for data corruption, between io
enqueue and user-space driven queue flush.

I saw Mike's Aug 2005 patches for scsi errors translation in block-layer
errors, which were a usable infrastructure to implement the desired
behaviour. Is some variant of this work headed for the upstream kernel ?

Regards,
cvaroqui
