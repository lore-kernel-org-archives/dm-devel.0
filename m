From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: multipath: Failing Path
Date: Wed, 18 Jun 2008 20:07:05 -0700
Message-ID: <110b17190806182007j31843efas1278946c186f016e@mail.gmail.com>
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

I recently sent a mail describing the problem I am facing on failback
(I have copied the same at the end of this mail)
I am facing this problem with RHEL 5.1.

In all the logs I have collected for this failure, one thing thats
distinctive is:

- When a failover happens, error handler function from my device
handler is called; after which the path is marked as failed with
printk "device-mapper: multipath: Failing Path 8:XX". I know this as I
have added some debug prints in my error handler.

- But while the preferred controller is coming up, due to some failure
the only surviving paths are marked as fail with the printk
"device-mapper: multipath: Failing Path 8:XX" but this time it does
not call my device handler for error handling.

Why so?
I search the device-mapper code for the string "Failing path" and
could find it only in one function fail_path(path) and this function
gets called only in 2 condition, either as ap art of
dm_dpg_init_complete() OR do_end_io(). In both the conditions, I
should see some prints from my device handler but I don't.

Who else or in what other conditin can I get the printk
"device-mapper: multipath: Failing Path 8:XX"??

Any kind of help is much appreciated.

Thanks and Regards,
Pradipmaya.



<snip>
Hi All,

I am facing a weird problem with RHEL.

Following is the setup I have:
-       RHEL 5.1 OS installed on diskless blades
-       Blades connected to 2 controllers (so basically 2 paths)
-       Trying for ALUA support
-       For ALUA support I derived my code from Hannes check for explicit
ALUA support.
-       Path_grouping_policy            group_by_prio
-       Features                        1 "queue_if_no_path"
-       No_path_retry           20

Problem:
-       When the failover happens, the standby paths are made active by
firing STPG. So far so good.
-       When the failback happens, some how the standby paths are failed
(with messages Failing path 8:XX) even before the preferred controller
comes up.
-       If the failure is show once, init_function is called again and thing
move fine, but in case this same error happens twice, the path is
marked as failure. In these situation as there are no paths, either
hangs or mounted as read-only.
-       This does not happen immediately, it happens in hour or so when I Am
trying continuous failover failback with some gap in between 2
operations.

Why does the path fail in such scenarios?
How can this be prevented?

Please suggest.

Regards,
Pradipmaya.
<snip>
