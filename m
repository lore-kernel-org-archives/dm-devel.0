From: dwysocha@redhat.com
Subject: [patch 0/3] Add HP hardware handler support to dm-mp
Date: Thu, 24 May 2007 01:17:47 -0400
Message-ID: <20070524051747.219219749@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

The following 3 patches add HP hardware handler support to dm-multipath.
The first patch is very basic and provides a baseline of support but it is not
complete (has no retries, error code handling, etc).  Second and third patches
add retries and some error code handling.

-- 
