From: "bart brooks" <bart_brooks@hotmail.com>
Subject: Multipath and SCSI_STATUS
Date: Thu, 27 Apr 2006 17:26:31 +0000
Message-ID: <BAY114-F14D9914F1A5FF57AFCA4A79DBD0@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

I have a question related to SCSI_STATUS and multipath, which I hope someone 
can answer.
Will a  hardware_handler get called at its error function when a Unit 
Attention occurs on a multipath device, will the Sense Status be available.

I’m running RHEL 4 update 2

Thanks in advance,
Bart
