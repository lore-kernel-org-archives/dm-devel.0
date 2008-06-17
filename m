From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Problem with ALUA Support
Date: Mon, 16 Jun 2008 20:56:33 -0700
Message-ID: <110b17190806162056y10e59a0cu36146bcd3ccddd75@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi All,

I am facing a weird problem with RHEL.

Following is the setup I have:
-	OS installed on diskless blades
-	Blades connected to 2 controllers (so basically 2 paths)
-	Trying for ALUA support
-	For ALUA support I derived my code from Hannes check for explicit
ALUA support.
-	Path_grouping_policy		group_by_prio
-	Features			1 "queue_if_no_path"
-	No_path_retry		20

Problem:
-	When the failover happens, the standby paths are made active by
firing STPG. So far so good.
-	When the failback happens, some how the standby paths are failed
(with messages Failing path 8:XX) even before the preferred controller
comes up.
-	If the failure is show once, init_function is called again and thing
move fine, but in case this same error happens twice, the path is
marked as failure. In these situation as there are no paths, either
hangs or mounted as read-only.
-	This does not happen immediately, it happens in hour or so when I Am
trying continuous failover failback with some gap in between 2
operations.

Why does the path fail in such scenarios?
How can this be prevented?

Please suggest.

Regards,
Pradipmaya.
