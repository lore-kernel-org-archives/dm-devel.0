From: David Wysochanski <davidw@netapp.com>
Subject: multipathd:checkerloop() - why not check path state
 before calling pathinfo(), which calls path priority callouts?
Date: Wed, 01 Mar 2006 14:54:47 -0500
Message-ID: <4405FC07.9090006@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Looking through the mulitpathd code, in particular checkerloop() and the
below snippit.  I'm wondering why the path state isn't checked and then the
pathinfo() not called if the path state is PATH_DOWN (or maybe !PATH_UP).
Seems like we shouldn't be trying to refresh the priority if we know the
path is bad anyway, since the callouts all issue scsi passthru commands,
which will always fail.  Is this right or am I missing something?

Thanks.



            /*
             * path prio refreshing
             */
            condlog(4, "path prio refresh");
            pathinfo(pp, conf->hwtable, DI_PRIO);

            if (need_switch_pathgroup(pp->mpp, 0)) {
                if (pp->mpp->pgfailback > 0 &&
                    pp->mpp->failback_tick <= 0)
                    pp->mpp->failback_tick =
                        pp->mpp->pgfailback + 1;
                else if (pp->mpp->pgfailback ==
                        -FAILBACK_IMMEDIATE)
                    switch_pathgroup(pp->mpp);
            }
