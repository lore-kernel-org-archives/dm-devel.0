From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: multipath -ll output discrepancy for IBM 1818 on
 SLES 11	SP1....
Date: Fri, 01 Apr 2011 15:58:52 +0100
Message-ID: <4D95E82C.4010805@redhat.com>
References: <889038.49843.qm@web112308.mail.gq1.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <889038.49843.qm@web112308.mail.gq1.yahoo.com>
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
Cc: Dharmesh Kamdar <kamdard71@yahoo.com>
List-Id: dm-devel.ids

On 04/01/2011 03:31 PM, Dharmesh Kamdar wrote:
> So, my question is : even if we mention 
>                              features "2 pg_init_retries 50" 
> 
> why are we seeing " features='3 queue_if_no_path pg_init_retries 50' 
> hwhandler='1 rdac' wp=rw" in the multipath -ll output ?
> 
> 1) Where is this "3" coming from  ? and what is it's significance ?? 

It's the count if items to parse on the rest of the features line.

> 2) Is this "3" next to the features in "multipath -ll" output as expected (even 
> though we mention "2 pg_init_retries 50" ) in our multipath.conf ??

The format of the features field is:

FeatureCount# Feature/param0 Feature/param1 ... Feature/paramN

The 3 indicates three features/parameters. The first is "queue_if_no_path"
(which is implied by the "no_path_retry 30" in your device block - no_path_retry
requires the queue_if_no_path feature be enabled at the device-mapper level).
The 2nd and 3rd are the pg_init_retries feature and its parameter.

Regards,
Bryn.
