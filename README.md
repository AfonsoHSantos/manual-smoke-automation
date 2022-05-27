## Automation Status

1. Validate the name of the compressed bundle ✅
2. Assert the .liferay-home file is present within the liferay home directory ✅	
3. Validate the contents within the readme.html in the liferay home directory ✅	
4. Assert the hash within the .githash file in the liferay home directory ✅	
5. Validate the contents within the copyright.txt file within the /license directory ✅	
6. Assert the /deploy directory is empty ✅	
7. Assert the /logs directory is empty ✅	
8. Assert the osgi/state directory is present and is populated ✅	
9. Assert the osgi/modules and osgi/portal folders are empty ✅	
10. Assert the osgi/marketplace folder is populated with app LPKGs ✅	
11. Assert standalone and bundled app LPKGs are present in the /marketplace folder ✅	
12. Assert jar versions within LPKGs are correct ❌
13. Assert the LPKG names are correct ✅	
14. Assert the startup log Portal name, version, version name, release date, etc ✅	
15. Assert there are no startup errors ✅	
16. Assert "Powered By Liferay" appears at the footer of the home page ✅	
17. Assert the Liferay logo icon and the default Liferay site name are correct ✅	
18. Assert responsiveness of pre-compiled JSPs by navigating around Portal ✅	
