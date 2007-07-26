From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch 3/3] Add retries to hp hardware handler if
	path	initialization command completes with a check condition.
Date: Thu, 26 Jul 2007 10:16:07 -0500
Message-ID: <46A8BAB7.4060003@cs.wisc.edu>
References: <20070726044447.846195205@redhat.com>
	<20070726044720.980015296@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070726044720.980015296@redhat.com>
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

dwysocha@redhat.com wrote:


  struct hp_sw_context {
  	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	unsigned argc;
  };


argc does not seem to be used anywhere that I could see.

Also do not forget your signed off line.
