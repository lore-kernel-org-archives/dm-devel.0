From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Problem with ALUA Handler
Date: Thu, 8 Nov 2007 13:32:41 -0700
Message-ID: <110b17190711081232p41664102tfc0f3dea861d322a@mail.gmail.com>
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

Hi,

I tried compiling ALUA handler code from Hannes Reincke
(https://www.redhat.com/archives/dm-devel/2007-October/msg00033.html)
on kernel 2.6.18 and with few modifications it did fine.

I was even able to load it, but it fails for the std inquiry and hence
does not do anything further. It returns error that the controller
does not support TPGS.

I verified with the analyser that the inquiry command is actually
reaching the controller and it's returning proper values.

Could someone please let me know what am I missing here?

Thanks and Regards,
Pradipmaya.
