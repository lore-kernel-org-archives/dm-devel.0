From: Daniel Lang <langd@lanl.gov>
Subject: RHEL 6 I/O error messages during booting
Date: Fri, 28 Oct 2011 15:13:54 -0600
Message-ID: <4EAB1B12.3080606@lanl.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

We are having an issue that appears to be related to fact that the 
scsi_dh_rdac module is loaded after the qla FC driver and  SAN paths 
coming up before rdac can handle them. How can we change the order of 
kernel modules so that the scsi_dh_rdac module is loaded before the FC 
driver?
We are getting long boot times and random crashes due to this issue
