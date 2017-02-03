From: M Muneendra Kumar <mmandala@brocade.com>
Subject: [PATCH 0/1] multipathd: deterministic io throughput in
	multipath
Date: Fri,  3 Feb 2017 20:16:56 +0530
Message-ID: <1486133217-19098-1-git-send-email-mmandala@brocade.com>
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
List-Id: dm-devel.ids

This patch adds three configuration parameters, "san_path_err_threshold",
"san_path_err_recovery_time" and "san_path_err_forget_rate".
multipathd will watch paths and check how many times a path has been
failed due to errors.If the number of failures on a particular path is
greater then the san_path_err_threshold then the path will not  reinstante
till san_path_err_recovery_time.These path failures should occur within a
san_path_err_forget_rate checks, if not we will consider the path is good enough
to reinstantate.If it is the only available path, it will immediately be
reintegrated.

This helps us to place the path in failed state if we hit lot of errors on a particular path 
due to network /target issues and allow the admin to rectify the errors on a path.


M Muneendra Kumar (1):
  multipathd: deterministic io throughput in multipath

 libmultipath/config.c      |  6 ++++
 libmultipath/config.h      |  9 +++++
 libmultipath/configure.c   |  3 ++
 libmultipath/defaults.h    |  3 +-
 libmultipath/dict.c        | 86 ++++++++++++++++++++++++++++++++--------------
 libmultipath/dict.h        |  3 +-
 libmultipath/propsel.c     | 48 ++++++++++++++++++++++++--
 libmultipath/propsel.h     |  3 ++
 libmultipath/structs.h     | 14 +++++---
 multipath/multipath.conf.5 | 57 ++++++++++++++++++++++++++++++
 multipathd/main.c          | 83 ++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 281 insertions(+), 34 deletions(-)

-- 
1.8.3.1
