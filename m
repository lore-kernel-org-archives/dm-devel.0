From: <Yanqing_Liu@Dell.com>
Subject: Quick failover/failback
Date: Tue, 11 Nov 2008 10:58:43 -0600
Message-ID: <00FE57DD11E3A94893D5BD54C3358BE884BFEB@AUSX3MPC128.aus.amer.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

Currenly, when failback happens, IO's will be held until failback is
completed. After failback happens, IO's will resume on alternate
controller.

Although this will not induce IO failure, the delay in resuming IO will
possibly impact clients that may be accessing the server. If as the path
failover is completed, if a failover is again initiated, it delays when
IO can start running normally. This is a QoS issue.

To prevent quick failover/failback that can be result in IO failure,
hysteresis needs to be implemented, such that after redundancy has been
restored failback is only executed after the existing backlog of pending
IOs have been completed.

When failback is scheduled to happen, newly issued IO's will be queued,
but failback will be held until all backlog IO's are completed.=20

Any thoughts on this?

Thanks,
Yanqing
