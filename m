From: "goggin, edward" <egoggin@emc.com>
Subject: RE: dm-devel Digest, Vol 16, Issue 20
Date: Tue, 21 Jun 2005 15:00:27 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AAEA@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 20 Jun 2005 20:46:34 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote

> Speaking of optimization, have you witnessed too the ~20% performance
> decrease with multi-path PG ?

Sorry, but I haven't been paying enough attention to this performance
degradation thread.

I just tried a simple sequential block file system and raw (4kb)
writing and read/writing for single dd(1) thread of 2GB LU with multibus
path grouping policy (EMC Symmetrix) with 2 paths and a 100 minio count
value and noticed very little drop (5% elapsed time as reported by time(1))
in throughput verses doing the same with the native scsi device path.
Five percent is certainly livable.  I did not compare with the failover
path group policy though.
