From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/3] dm-integrity: make it possible to change the
	size of dm-integrity device
Date: Thu, 30 Jan 2020 18:25:39 +0100
Message-ID: <20200130172539.890730920@debian-a64.vm>
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
To: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This patchset makes it possible to enlarge or shrink a dm-integrity device.

Without this patchset, dm-integrity would set the field
provided_data_sectors only once and would not change it when being
reloaded with different size.

This patch makes dm-integrity update provided_data_sectors at each
invocation.

Mikulas
