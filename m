From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 0/4][RFC] dm-core: full barrier support
Date: Thu, 08 Jan 2009 17:13:00 +0100
Message-ID: <4966260C.6070602@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

This patchset is just resend for new kernel of a barrier implementation.

Please note that it is more request for discussion...

[PATCH 1/4] dm-core: remove current partial barrier implementation

[PATCH 2/4] dm-core: Add zero-size barrier processing to device-mapper

[PATCH 3/4] dm-core: Process barrier request with payload in device-mapper

[PATCH 4/4] dm-core: Implement waiting for barrier in dm_suspend request


Milan
--
mbroz@redhat.com
