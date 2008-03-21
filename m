From: Achim Warnecke <achim.warnecke@de.ibm.com>
Subject: Policy for using dm-multipather with SELinux enforced
Date: Fri, 21 Mar 2008 13:42:06 +0100
Message-ID: <OF4B4F2CA0.71297968-ONC1257413.00448630-C1257413.0045C56F@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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


Hello all,
is there a policy available which describes the setup of SELinux when used
together with dm-multipather under RedHat 5.1 ?
We saw the problem, that a enforced SELinux caused the multipather deamon
to die. The messages log says:
Mar 19 17:26:12 localhost setroubleshoot:      SELinux is preventing
/sbin/multipathd (lvm_t) "write" to cache (var_t).
     For complete SELinux messages. run sealert -l
1635682f-989b-42e2-acc8-43cc8f80de6b
The dm-multipather status shows:
[root@x3655-lab-01a ~]# service multipathd status
multipathd dead but pid file exists
Kind regards, Achim
