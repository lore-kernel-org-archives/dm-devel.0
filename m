From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/15] Fifteen multipath-tools patches
Date: Fri, 21 Oct 2016 11:40:29 -0700
Message-ID: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Christophe,

It would be appreciated if you would consider this patch series for 
inclusion in the multipath-tools repository. The changes in this patch 
series are:
- A build fix for musl-libc.
- A fix for a deadlock during shutdown.
- A bunch of patches that address warnings reported by the sparse
   static analyzer.

Thanks,

Bart.
