From: Dale.R.Fowle@seagate.com
Subject: no_path_retry question
Date: Wed, 31 Jan 2007 15:32:43 -0700
Message-ID: <OFA96391CF.1F30E02D-ON87257274.007B864A-87257274.007BD911@seagate.com>
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


Hi all, I have a question on what the retry in the no_path_retry option
refers to. If we use a number like 60, instead of "fail" or "queue", does
Multipath Tools retry an IO at one second intervals? Or is this retry based
off of the SCSI timeout value within the kernel?

Thanks,
Dale
