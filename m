From: Dharmesh Kamdar <kamdard71@yahoo.com>
Subject: multipatd -k "show config" related query....
Date: Mon, 23 May 2011 11:34:17 -0700 (PDT)
Message-ID: <419659.13658.qm@web112317.mail.gq1.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

Hi,

The "show config" option in the interactive multipath shell (multipathd -k), 
scrolls up the screen...Even scrolling up using scroll-bar does NOT show 
complete configuration since it is cut-off at the top of the screen (even with 
the terminal window maximized).

Is there  any way to circumvent it (like piping it to "more" or "less" within  
that multipath shell OR redirecting it a text  file from within that multipath 
shell) ?

(running RHEl 5.5 x86-64, device-mapper-multipath-0.4.7-34.el5_5.1).

Thanks,
Dharmesh.
