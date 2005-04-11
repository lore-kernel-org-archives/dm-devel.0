From: Daniel Phillips <phillips@redhat.com>
Subject: Dumb question
Date: Mon, 11 Apr 2005 15:01:40 -0400
Message-ID: <200504111501.40423.phillips@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi guys,

Here is a dumb question:  Why does dmsetup use (start, length) for each 
target line instead of just (length)?  Is it useful to leave some parts 
of a virtual device unmapped, and if so, why not require them to be 
mapped explicitly to zero or error?

Regards,

Daniel
