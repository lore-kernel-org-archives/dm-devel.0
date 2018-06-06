From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/9] dm-integrity patches
Date: Wed, 06 Jun 2018 17:33:07 +0200
Message-ID: <20180606153307.423442513@debian.vm>
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
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Here I'm sending the dm-integrity patches. It would be nice if you could
send them in this merge window.

The major changes are:
* avoid starvation in range locking
* use external metadata device
* recalculate integrity tags automatically

Mikulas
