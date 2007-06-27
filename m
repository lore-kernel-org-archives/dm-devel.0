From: "Jitendra Bhivare" <jitendra.bhivare@gmail.com>
Subject: dm-multipath MP_RETRY_PG_INIT patch
Date: Wed, 27 Jun 2007 11:55:34 +0530
Message-ID: <50d45ed90706262325k3bfcdf9em14c6a3eaffb3d895@mail.gmail.com>
References: <50d45ed90706210718y4ef5d66en433c9444d227ff65@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2098793151=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50d45ed90706210718y4ef5d66en433c9444d227ff65@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, michaelc@cs.wisc.edu
List-Id: dm-devel.ids

--===============2098793151==
Content-Type: multipart/alternative;
	boundary="----=_Part_3109_5406487.1182925534748"

------=_Part_3109_5406487.1182925534748
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

In dm-multipath framework, using the hw-handler's error-function entry
point, nothing can be known about the reason for IO failure. From this
function MP_FAIL_PATH/MP_BYPASS_PG/MP_ERROR_IO can returned.
If the same path needs to be tried (i.e. in pg_init) to figure out the
reason for failure there is no way to tell that to dm-multipath.

One way to do so, is to return MP_RETRY_PG_INIT from hw_handler's
error function. This would set current_pgpath and current_pg to NULL
which would trigger pg_init. The path won't fail until pg_init says so.

Should this option MP_RETRY_PG_INIT be added to dm-multipath?

Thanks & Regards,

JB

------=_Part_3109_5406487.1182925534748
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<span>Hi,<br><br>In dm-multipath framework, using the hw-handler&#39;s error-function entry point,&nbsp;nothing&nbsp;can&nbsp;be&nbsp;known&nbsp;about&nbsp;the reason&nbsp;for&nbsp;IO&nbsp;failure.&nbsp;From this<br>function MP_FAIL_PATH/MP_BYPASS_PG/MP_ERROR_IO can returned.
<br>If the same path needs to be tried&nbsp;(i.e.&nbsp;in&nbsp;pg_init) to figure out the<br>reason for failure there is no way to tell that to dm-multipath. <br><br>One way to do so, is to return&nbsp;MP_RETRY_PG_INIT&nbsp;from&nbsp;hw_handler&#39;s<br>
 error function. This would set current_pgpath and current_pg to NULL<br>which would trigger pg_init. The path won&#39;t fail   until pg_init says so.<br><br>Should this option MP_RETRY_PG_INIT be added to dm-multipath?<br>
 <br>Thanks &amp; Regards,<br><br>JB<br><br><br><br></span>

------=_Part_3109_5406487.1182925534748--


--===============2098793151==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2098793151==--
