From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: multipathd will not set the iscsi session tmo after
 iscsi sesstion recovery
Date: Thu, 12 Apr 2018 16:46:49 +0800
Message-ID: <de942eab-4456-fc6d-d588-79bb7a0513e1@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
Cc: shinya.narahara@oracle.com
List-Id: dm-devel.ids

Hi Dear all

Our customer complained that the iscsi session tmo parameters doesn't match with
the multipath config.

When the iscsi session fails and do the recovery, iscsid will set parameters again.
But this will overwrite the ones which has been set by multipathd.
And multipathd will not set the iscsi session tmo parameters when path down and up.

Is there any solution for this ?

Thanks
Jianchao
